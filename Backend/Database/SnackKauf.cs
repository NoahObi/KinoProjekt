using System;
using System.Collections.Generic;

namespace Database;

public partial class SnackKauf
{
    public decimal Snackkaufid { get; set; }

    public decimal? Snackid { get; set; }

    public decimal? Kundeid { get; set; }

    public decimal? Zahlungsid { get; set; }

    public byte? Menge { get; set; }

    public DateTime? Kaufdatum { get; set; }

    public virtual Kunde? Kunde { get; set; }

    public virtual Snack? Snack { get; set; }

    public virtual Zahlung? Zahlungs { get; set; }
}
