using GDWeave;

namespace Buttplug;

public class Mod : IMod {
    public Config Config;

    public Mod(IModInterface modInterface) {
        this.Config = modInterface.ReadConfig<Config>();
        modInterface.Logger.Information("Loaded Buttplug");

        modInterface.Logger.Information("Injecting fishing hooks");
        modInterface.RegisterScriptMod(new FishingInject(modInterface));
    }

    public void Dispose() {
        // Cleanup anything you do here
    }
}


