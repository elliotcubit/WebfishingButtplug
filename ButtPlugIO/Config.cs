using System.Text.Json.Serialization;

namespace Buttplug;

public class Config {
    [JsonInclude] public bool SomeSetting = true;
}
