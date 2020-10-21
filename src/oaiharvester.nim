import oaitools, strformat, os, progress, argparse, times

proc process_sets(oai_connection: OaiRequest, a_date, metadata_prefix: string): int =
  var 
    sets = oai_connection.list_sets()
    bar = newProgressBar(total=len(sets))
  echo fmt"{'\n'}Harvesting all records since {a_date} as {metadata_prefix}.{'\n'}"
  bar.start()
  for i in 1..len(sets):
    oai_connection.oai_set = sets[i-1]
    discard oai_connection.harvest_metadata_records(metadata_format=metadata_prefix, output_directory=fmt"{getCurrentDir()}/{sets[i-1]}", identifier=true, from_date=a_date, replace_filename="oai:trace.tennessee.edu:")
    bar.increment()
  bar.finish()
  len(sets)

proc process_set(oai_connection: OaiRequest, a_date, metadata_prefix: string, oaiset: string): string =
  echo fmt"{'\n'}Harvesting all records since {a_date} as {metadata_prefix} from set {oaiset}.{'\n'}"
  oai_connection.oai_set = oaiset
  discard oai_connection.harvest_metadata_records(metadata_format=metadata_prefix, output_directory=fmt"{getCurrentDir()}/{oaiset}", identifier=true, from_date=a_date, replace_filename="oai:trace.tennessee.edu:")
  "Done."

when isMainModule:
  var
    p = newParser(fmt"Harvest  OAI Records"):
      option("-d", "--date", help="Download records since this date as yyyy-MM-dd.  Defaults to yesterday.", default="yesterday")
      option("-m", "--metadata_format", help="Specifiy metadata format.", default="qdc")
      option("-e", "--endpoint", help="Specify OAI Endpoint")
      option("-s", "--oaiset", help="Specify OAI Set")
    argv = commandLineParams()
    opts = p.parse(argv)
    datestring: string
  if opts.endpoint != "":
    let
      harvester = newOaiRequest(opts.endpoint)
    case opts.date
    of "yesterday":
      datestring = $(now() - 1.days)
    else:
      datestring = opts.date
    if opts.oaiset == "":
      discard process_sets(harvester, datestring, opts.metadata_format)
    else:
      discard process_set(harvester, datestring, opts.metadata_format, opts.oaiset)
  else:
    echo "You must specify an OAI endpoint!"
