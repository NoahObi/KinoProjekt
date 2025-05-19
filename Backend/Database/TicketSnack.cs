using System;
using System.Collections.Generic;

namespace Database;

public partial class TicketSnack
{
    public decimal Ticketid { get; set; }

    public decimal Snackid { get; set; }

    public byte? Menge { get; set; }

    public virtual Snack Snack { get; set; } = null!;

    public virtual Ticket Ticket { get; set; } = null!;
}
