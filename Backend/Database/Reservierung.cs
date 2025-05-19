using System;
using System.Collections.Generic;

namespace Database;

public partial class Reservierung
{
    public decimal Reservierungid { get; set; }

    public decimal? Kundeid { get; set; }

    public decimal? Vorstellungid { get; set; }

    public DateTime? Reservierungsdatum { get; set; }

    public string? Reservierungsstatus { get; set; }

    public virtual Kunde? Kunde { get; set; }

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();

    public virtual Vorstellung? Vorstellung { get; set; }
}
