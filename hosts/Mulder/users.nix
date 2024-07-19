{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "Derek Graham";
      extraGroups = [
        "networkmanager"
        "plex"
        "docker"
        "video"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
      ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [
      ];
    };
  nginx = {
    description = "nginx";
    extraGroups = [ "nginx" "networkmanager" "docker" "wheel" ];
    isSystemUser = true;
    password = "098825";
    home = "/var/www/papalpenguin.com";
  };
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
