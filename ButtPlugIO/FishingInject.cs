using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;
using GDWeave;

namespace Buttplug;

public class FishingInject : IScriptMod
{
    public IModInterface modInterface;

    const bool go = true;

    public FishingInject(IModInterface mi) {
        modInterface = mi;
    }

    public bool ShouldRun(string path) => path == "res://Scenes/Minigames/Fishing3/fishing3.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        modInterface.Logger.Information("In injection function");

        var extendsWaiter = new MultiTokenWaiter([
            t => t.Type is TokenType.PrExtends,
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

    
        var clickHook = new MultiTokenWaiter([
            t => t.Type is TokenType.PrVar,
            t => t is IdentifierToken { Name:"reel_sound"},
            t => t.Type is TokenType.OpEqual,
            t => t is ConstantToken { Value: BoolVariant },
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

        var yankHook = new MultiTokenWaiter([
            t => t is IdentifierToken { Name:"ys"},
            t => t.Type is TokenType.Period,
            t => t is IdentifierToken { Name:"health"},
            t => t.Type is TokenType.OpAssignSub,
            t => t is IdentifierToken { Name:"params"},
            t => t.Type is TokenType.BracketOpen,
            t => t is ConstantToken { Value: StringVariant },
            t => t.Type is TokenType.BracketClose,
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

        var ready = new FunctionWaiter("_ready");
        var end = new FunctionWaiter("_reached_end");
        
        modInterface.Logger.Information("Parsing tokens");
        foreach (var token in tokens)
        {
            if (extendsWaiter.Check(token))
            {
                yield return token;

                yield return new Token(TokenType.Newline);

                yield return new Token(TokenType.PrOnready);
                yield return new Token(TokenType.PrVar);
                yield return new IdentifierToken("ButtPlugIO");
                yield return new Token(TokenType.OpAssign);
                yield return new IdentifierToken("get_node");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new ConstantToken(new StringVariant("/root/ButtPlugIO"));
                yield return new Token(TokenType.ParenthesisClose);

                yield return new Token(TokenType.Newline);
            }
            else if (clickHook.Check(token)) 
            {
                // This shit is broken and I don't care enough to fix it
                yield return token;

                if (false) {
                    modInterface.Logger.Information("Injecting reel hook");
                    // if not over and not at_yank: Buttplug._reel_hook(reeling);
                    yield return new Token(TokenType.CfIf);
                    yield return new Token(TokenType.OpNot);
                    yield return new IdentifierToken("over");
                    yield return new Token(TokenType.OpAnd);
                    yield return new Token(TokenType.OpNot);
                    yield return new IdentifierToken("at_yank");
                    yield return new Token(TokenType.Colon);
                    yield return new Token(TokenType.Newline, 2);
                    yield return new IdentifierToken("ButtPlugIO");
                    yield return new Token(TokenType.Period);
                    yield return new IdentifierToken("_reel_hook");
                    yield return new Token(TokenType.ParenthesisOpen);
                    yield return new IdentifierToken("reeling");
                    yield return new Token(TokenType.ParenthesisClose);
                    yield return new Token(TokenType.Newline, 1);
                }
                
            }
            else if (yankHook.Check(token))
            {
                modInterface.Logger.Information("Injecting yank hook");
                yield return token;

                // Buttplug._yank_hook()
                if (go) {
                    yield return new IdentifierToken("ButtPlugIO");
                    yield return new Token(TokenType.Period);
                    yield return new IdentifierToken("_yank_hook");
                    yield return new Token(TokenType.ParenthesisOpen);
                    yield return new Token(TokenType.ParenthesisClose);
                    yield return new Token(TokenType.Newline, 1);
                }
               
            }
            else if (ready.Check(token))
            {
                modInterface.Logger.Information("Injecting start hook");
                yield return token;
                
                // Buttplug._start_hook()
                if (go) {
                    yield return new IdentifierToken("ButtPlugIO");
                    yield return new Token(TokenType.Period);
                    yield return new IdentifierToken("_start_hook");
                    yield return new Token(TokenType.ParenthesisOpen);
                    yield return new Token(TokenType.ParenthesisClose);
                    yield return new Token(TokenType.Newline, 1);
                }
                
            }
            else if (end.Check(token))
            {
                modInterface.Logger.Information("Injecting end hook");
                yield return token;
                
                // Buttplug._end_hook()
                if (go) {
                    yield return new IdentifierToken("ButtPlugIO");
                    yield return new Token(TokenType.Period);
                    yield return new IdentifierToken("_end_hook");
                    yield return new Token(TokenType.ParenthesisOpen);
                    yield return new Token(TokenType.ParenthesisClose);
                    yield return new Token(TokenType.Newline, 1);
                }
            }
            else
            {
                yield return token;
            }
        }
    }
}