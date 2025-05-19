using System;
using System.Collections.Generic;

namespace Database;

public partial class Zahlungsmethode
{
    public decimal Zahlungsmethodeid { get; set; }

    public string Methode { get; set; } = null!;

    public virtual ICollection<Zahlung> Zahlungs { get; set; } = new List<Zahlung>();
}
