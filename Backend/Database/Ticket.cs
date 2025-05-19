using System;
using System.Collections.Generic;

namespace Database;

public partial class Ticket
{
    public decimal Ticketid { get; set; }

    public decimal? Vorstellungid { get; set; }

    public decimal? Kundeid { get; set; }

    public string? Sitzplatz { get; set; }

    public decimal? Preisid { get; set; }

    public decimal? Zahlungsid { get; set; }

    public decimal? Reservierungid { get; set; }

    public virtual Kunde? Kunde { get; set; }

    public virtual Prei? Preis { get; set; }

    public virtual Reservierung? Reservierung { get; set; }

    public virtual ICollection<TicketSnack> TicketSnacks { get; set; } = new List<TicketSnack>();

    public virtual Vorstellung? Vorstellung { get; set; }

    public virtual Zahlung? Zahlungs { get; set; }
}
