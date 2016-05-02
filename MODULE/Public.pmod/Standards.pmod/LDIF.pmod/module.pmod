/*
 *
 * Author(s):
 *   Bertrand LUPART <bertrand.lupart@free.fr>
 */

string __version = "0.1";
string __author = "Bertrand LUPART <bertrand.lupart@free.fr>";
array __components = ({ "Public.pmod/Standards.pmod/LDIF.pmod/module.pmod" });



/******************************************************************************
                       Public.Standards.LDIF.LDIFIterator
 ******************************************************************************/

// Since that's a generic line Iterator, this can be used for parsing data from
// any source.
class LDIFIterator
{
  static int ldifline_index=-1; // current LDIF index
  static string ldifline_value="";

  // Is there still some data to read from the Iterator?
  static int data_remaining = 1;

  // line_iterator reads data a line at a time
  object line_iterator;

                               /* Iterator API */

  //! @param _input
  //! The file containing the LDIF data
  void create(Iterator _iterator)
  {
    line_iterator = _iterator;

    // Go to the next (first) item
    next();
  }

  // Do we have still some data in our Iterator?
  int `!()
  {
    // Nothing's left in the file, no more LDIF data
    return !data_remaining;
  }

  // Get next elements from the iterator
  LDIFIterator `+=(int steps)
  {
    for(int i=0; i<steps; i++)
    {
      string in = line_iterator->value();

      // If no data from the file iterator
      if (!in)
      {
        data_remaining=0; // there is no data remaining
//        ldifline_index = 0; // current LDIF line is empty
        return this; // exit
      }

      parse_ldif_line(in); // parse ldif and feed ldif_entries with them

      // Sanity check loop over the collected data

      // Go to the next element
      ldifline_index++;
      line_iterator->next();
    }

    return this;
  }

  // The current index for the iterator
  int index()
  {
    return ldifline_index;
  }

  // Increment the iterator
  int next()
  {
    `+=(1);
  }

  // The CSV data for our current index
  int|string value()
  {
    return ldifline_value;
  }

                       /* LDIFIterator-specific methods */

  //! Parses a string and tries to find some LDIF data in it.
  //!
  //! @param in
  //!  The line from the file we want to parse, as a string
  static void parse_ldif_line(string in)
  {
    write(in);
  }


}



/******************************************************************************
                           Public.Standards.LDIF.FILE
 ******************************************************************************/

class FILE
{
  inherit Stdio.FILE;

  // ldif_iterator reads a line at a time
  // a LDIF line can be splitted into multiple file lines
  object ldif_entry_iterator;

  string version = "0"; // default
/*
  void create(int|string|void file,void|string mode,void|int bits)
  {
    ::create(@args);
    version="1";
  }
*/

  void read_entry()
  {
    
  }
}

class LDIF
{
  // LDIF version
  static string version = "2";
  // Ordered LDIF entries
  static array(LDIFEntry) entries = ({ });

                                 /* Pike API */

  void create(void|int|string version)
  {
    
  }

  void add_entry(LDIFEntry entry)
  {
    // TODO : Keep entry ordered 
    entries += ({ entry });
  }

  protected mixed cast(string type)
  {
    switch(type)
    {
      case "string":
        return to_string();
        break;
      case "object":
        return this_object();
        break;
      default:
        werror("%O : unsupported cast to %s.", this(), type);

    }
  }

                              /* Class-specific */

  string to_string()
  {
    string out = "";

    out += sprintf("version: %s\r\n", version);

    foreach(entries, object entry)
    {
      out += (string)entry;
      out += "\r\n";
    }

    return out;
  }

}

class LDIFEntry
{
  static string dn = "";
  array(mapping) attributes = ({ });

  void create(string _dn)
  {
    dn = _dn; 
  }

  protected mixed cast(string type)
  {
    switch(type)
    {
      case "string":
        return to_string();
        break;
      case "object":
        return this_object();
        break;
      default:
        werror("%O : unsupported cast to %s.", this(), type);
    
    }
  }

  string to_string()
  {
    string out = "";

    out += sprintf("dn: %s\n\r", dn);

    foreach()
    {
      
    }
  }
}
