using System;
using System.Collections.Generic;

namespace Database;

public partial class Saal
{
    public decimal Saalid { get; set; }

    public string Saalname { get; set; } = null!;

    public byte? Kapazitaet { get; set; }

    public string? Typ { get; set; }

    public virtual ICollection<Vorstellung> Vorstellungs { get; set; } = new List<Vorstellung>();
}
