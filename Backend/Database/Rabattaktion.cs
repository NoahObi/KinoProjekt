using System;
using System.Collections.Generic;

namespace Database;

public partial class Rabattaktion
{
    public decimal Rabattid { get; set; }

    public string Name { get; set; } = null!;

    public byte? Prozentsatz { get; set; }

    public DateTime? Startdatum { get; set; }

    public DateTime? Enddatum { get; set; }

    public decimal? Filmid { get; set; }

    public virtual Film? Film { get; set; }

    public virtual ICollection<Film> Films { get; set; } = new List<Film>();
}
