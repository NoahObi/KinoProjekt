using System;
using System.Collections.Generic;

namespace Database;

public partial class Snack
{
    public decimal Snackid { get; set; }

    public string Name { get; set; } = null!;

    public decimal? Preisid { get; set; }

    public string? Beschreibung { get; set; }

    public virtual Prei? Preis { get; set; }

    public virtual ICollection<SnackKauf> SnackKaufs { get; set; } = new List<SnackKauf>();

    public virtual ICollection<TicketSnack> TicketSnacks { get; set; } = new List<TicketSnack>();
}
