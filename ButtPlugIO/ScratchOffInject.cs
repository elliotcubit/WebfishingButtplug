using GDWeave.Godot;
using GDWeave.Godot.Variants;
using GDWeave.Modding;
using GDWeave;

namespace Buttplug;

public class ScratchOffInject : IScriptMod
{
    public IModInterface modInterface;

    public ScratchOffInject(IModInterface mi) {
        modInterface = mi;
    }

    public bool ShouldRun(string path) => path == "res://Scenes/Minigames/ScratchTicket/scratch_ticket.gdc";

    public IEnumerable<Token> Modify(string path, IEnumerable<Token> tokens)
    {
        modInterface.Logger.Information("In injection function");

        var extendsWaiter = new MultiTokenWaiter([
            t => t.Type is TokenType.PrExtends,
            t => t.Type is TokenType.Newline
        ], allowPartialMatch: true);

        var scratched = new FunctionWaiter("_slot_scratched");
        
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
            else if (scratched.Check(token))
            {
                modInterface.Logger.Information("Injecting scratch-off hook");
                yield return token;
                
                // Buttplug._start_hook()
                yield return new IdentifierToken("ButtPlugIO");
                yield return new Token(TokenType.Period);
                yield return new IdentifierToken("_scratch");
                yield return new Token(TokenType.ParenthesisOpen);
                yield return new Token(TokenType.ParenthesisClose);
                yield return new Token(TokenType.Newline, 1);
            }
            else
            {
                yield return token;
            }
        }
    }
}