{ systemSops, ... }:
{
  secrets.anthropic_api_key = systemSops.secrets.anthropic_api_key.path;
  secrets.openai_api_key = systemSops.secrets.openai_api_key.path;
}
