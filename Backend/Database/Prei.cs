using System;
using System.Collections.Generic;

namespace Database;

public partial class Prei
{
    public decimal Preisid { get; set; }

    public decimal? Betrag { get; set; }

    public string? Beschreibung { get; set; }

    public virtual ICollection<Snack> Snacks { get; set; } = new List<Snack>();

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();

    public virtual ICollection<Vorstellung> Vorstellungs { get; set; } = new List<Vorstellung>();
}
