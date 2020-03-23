# Package

version       = "0.1.0"
author        = "Mark Baggett"
description   = "Harvests OAI Records from an Endpoint in a Specific Format"
license       = "WTFPL"
srcDir        = "src"
bin           = @["oaiharvester"]



# Dependencies

requires "nim >= 1.0.6"
requires "oaitools >=  0.2.4"
requires "argparse >= 0.10.0"
requires "progress >=  1.1.1"