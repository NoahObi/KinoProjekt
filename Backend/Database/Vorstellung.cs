using System;
using System.Collections.Generic;

namespace Database;

public partial class Vorstellung
{
    public decimal Vorstellungid { get; set; }

    public decimal? Filmid { get; set; }

    public decimal? Saalid { get; set; }

    public DateTime Startzeit { get; set; }

    public DateTime Endzeit { get; set; }

    public decimal? Preisid { get; set; }

    public virtual Film? Film { get; set; }

    public virtual Prei? Preis { get; set; }

    public virtual ICollection<Reservierung> Reservierungs { get; set; } = new List<Reservierung>();

    public virtual Saal? Saal { get; set; }

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();
}
