using System;
using System.Collections.Generic;

namespace Database;

public partial class Kunde
{
    public decimal Kundeid { get; set; }

    public string Vorname { get; set; } = null!;

    public string Nachname { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Telefon { get; set; }

    public DateTime? Geburtsdatum { get; set; }

    public string? Adresse { get; set; }

    public virtual ICollection<Reservierung> Reservierungs { get; set; } = new List<Reservierung>();

    public virtual ICollection<SnackKauf> SnackKaufs { get; set; } = new List<SnackKauf>();

    public virtual ICollection<Ticket> Tickets { get; set; } = new List<Ticket>();

    public virtual ICollection<Zahlung> Zahlungs { get; set; } = new List<Zahlung>();
}
