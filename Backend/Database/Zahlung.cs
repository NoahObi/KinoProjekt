using System;
using System.Collections.Generic;

namespace Database;

public partial class Zahlung
{
    public decimal Zahlungsid { get; set; }

    public decimal? Betrag { get; set; }

    public DateTime? Zahlungsdatum { get; set; }

    public decimal? Zahlungsmethodeid { get; set; }

    public decimal? Kundeid { get; set; }

    public virtual Kunde? Kunde { get; set; }

    public virtual ICollection<SnackKauf> SnackKaufs { get; set; } = new List<SnackKauf>();

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();

    public virtual Zahlungsmethode? Zahlungsmethode { get; set; }
}
