{ systemSops, ... }:
{
  secrets.anthropic_api_key = systemSops.secrets.anthropic_api_key.path;
}
