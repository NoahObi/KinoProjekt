using System;
using System.Collections.Generic;

namespace Database;

public partial class Film
{
    public decimal Filmid { get; set; }

    public string Titel { get; set; } = null!;

    public string Genre { get; set; } = null!;

    public decimal? Dauer { get; set; }

    public byte? Startjahr { get; set; }

    public string? Beschreibung { get; set; }

    public virtual ICollection<Rabattaktion> Rabattaktions { get; set; } = new List<Rabattaktion>();

    public virtual ICollection<Vorstellung> Vorstellungs { get; set; } = new List<Vorstellung>();

    public virtual ICollection<Rabattaktion> Rabatts { get; set; } = new List<Rabattaktion>();
}
