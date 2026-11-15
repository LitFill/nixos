{ ... }: {
  flake.nixosModules = {
    keyd =
      { ... }:
      let
        inherit (builtins) isString;
        intoString = v: if isString v then v else toString v;
        lettermod = mod: key: lettermod' mod key { };
        lettermod' =
          mod: key:
          {
            idle-timeout ? 150,
            hold-timeout ? 200,
          }:
          let
            idle-timeout' = intoString idle-timeout;
            hold-timeout' = intoString hold-timeout;
          in
          "lettermod(${mod}, ${key}, ${idle-timeout'}, ${hold-timeout'})";
        macro = keys: "macro(${keys})";
        alt = "alt";
        meta = "meta";
        control = "control";
        shift = "shift";
      in
      {
        # Keyd config
        services.keyd = {
          enable = true;
          keyboards = {
            default = {
              ids = [ "*" ];
              settings = {
                main = {
                  # lettermod(<layer>, <key>, <idle timeout>, <hold timeout>)
                  a = lettermod alt "a";
                  s = lettermod meta "s";
                  d = lettermod shift "d";
                  f = lettermod control "f";

                  j = lettermod control "j";
                  k = lettermod shift "k";
                  l = lettermod meta "l";
                  semicolon = lettermod alt ";";

                  # Aktivasi Layer Prog
                  # Menahan Caps Lock akan mengaktifkan layer [prog]
                  capslock = "layer(prog)";
                };

                prog = {
                  # Navigasi ala Vim
                  h = "left";
                  j = "down";
                  k = "up";
                  l = "right";

                  # Simbol-simbol utama Prog
                  n = macro "->";
                  p = macro "<-";
                  c = macro "::";
                  g = macro "=>";
                  ";" = macro ":=";
                  t = macro "|>";
                  f = macro "<|";

                  # Simbol umum lainnya
                  space = "_";
                  d = "$";
                  b = "\\";
                  e = "=";
                  v = "|";
                  a = "&";
                  q = "+";
                  w = "*";

                  # Pasangan kurung
                  u = "(";
                  i = ")";

                  # Easy control
                  "," = "backspace";
                  "." = "delete";
                };
              };
            };
          };
        };
      };
  };
}
