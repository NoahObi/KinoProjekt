using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Database;

public partial class DatabaseContext : DbContext
{
    public DatabaseContext()
    {
    }

    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options)
    {
    }

    public virtual DbSet<EmpDetailsView> EmpDetailsViews { get; set; }

    public virtual DbSet<Film> Films { get; set; }

    public virtual DbSet<Kunde> Kundes { get; set; }

    public virtual DbSet<Preis> Preis { get; set; }

    public virtual DbSet<Rabattaktion> Rabattaktions { get; set; }

    public virtual DbSet<Reservierung> Reservierungs { get; set; }

    public virtual DbSet<Saal> Saals { get; set; }

    public virtual DbSet<Snack> Snacks { get; set; }

    public virtual DbSet<SnackKauf> SnackKaufs { get; set; }

    public virtual DbSet<Ticket> Tickets { get; set; }

    public virtual DbSet<TicketSnack> TicketSnacks { get; set; }

    public virtual DbSet<Vorstellung> Vorstellungs { get; set; }

    public virtual DbSet<Zahlung> Zahlungs { get; set; }

    public virtual DbSet<Zahlungsmethode> Zahlungsmethodes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseOracle("User Id=C##KAISERD21065;Password=Kaidan123!;Data Source=10.10.0.177:1521/ora23.htl.grieskirchen.local");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .HasDefaultSchema("C##KAISERD21065")
            .UseCollation("USING_NLS_COMP");

        modelBuilder.Entity<EmpDetailsView>(entity =>
        {
            





            entity
                .HasNoKey()
                .ToView("EMP_DETAILS_VIEW");

            entity.Property(e => e.City)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("CITY");
            entity.Property(e => e.CommissionPct)
                .HasColumnType("NUMBER(2,2)")
                .HasColumnName("COMMISSION_PCT");
            entity.Property(e => e.CountryId)
                .HasMaxLength(2)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("COUNTRY_ID");
            entity.Property(e => e.CountryName)
                .HasMaxLength(40)
                .IsUnicode(false)
                .HasColumnName("COUNTRY_NAME");
            entity.Property(e => e.DepartmentId)
                .HasPrecision(4)
                .HasColumnName("DEPARTMENT_ID");
            entity.Property(e => e.DepartmentName)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("DEPARTMENT_NAME");
            entity.Property(e => e.EmployeeId)
                .HasPrecision(6)
                .HasColumnName("EMPLOYEE_ID");
            entity.Property(e => e.FirstName)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("FIRST_NAME");
            entity.Property(e => e.JobId)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("JOB_ID");
            entity.Property(e => e.JobTitle)
                .HasMaxLength(35)
                .IsUnicode(false)
                .HasColumnName("JOB_TITLE");
            entity.Property(e => e.LastName)
                .HasMaxLength(25)
                .IsUnicode(false)
                .HasColumnName("LAST_NAME");
            entity.Property(e => e.LocationId)
                .HasPrecision(4)
                .HasColumnName("LOCATION_ID");
            entity.Property(e => e.ManagerId)
                .HasPrecision(6)
                .HasColumnName("MANAGER_ID");
            entity.Property(e => e.RegionName)
                .HasMaxLength(25)
                .IsUnicode(false)
                .HasColumnName("REGION_NAME");
            entity.Property(e => e.Salary)
                .HasColumnType("NUMBER(8,2)")
                .HasColumnName("SALARY");
            entity.Property(e => e.StateProvince)
                .HasMaxLength(25)
                .IsUnicode(false)
                .HasColumnName("STATE_PROVINCE");
        });

        modelBuilder.Entity<Film>(entity =>
        {
            entity.HasKey(e => e.Filmid).HasName("SYS_C00196454");

            entity.ToTable("FILM");

            entity.Property(e => e.Filmid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("FILMID");
            entity.Property(e => e.Beschreibung)
                .HasMaxLength(1000)
                .IsUnicode(false)
                .HasColumnName("BESCHREIBUNG");
            entity.Property(e => e.Dauer)
                .HasColumnType("NUMBER")
                .HasColumnName("DAUER");
            entity.Property(e => e.Genre)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("GENRE");
            entity.Property(e => e.Startjahr)
                .HasPrecision(4)
                .HasColumnName("STARTJAHR");
            entity.Property(e => e.Titel)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("TITEL");

            entity.HasMany(d => d.Rabatts).WithMany(p => p.Films)
                .UsingEntity<Dictionary<string, object>>(
                    "FilmRabattaktion",
                    r => r.HasOne<Rabattaktion>().WithMany()
                        .HasForeignKey("Rabattid")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("SYS_C00196466"),
                    l => l.HasOne<Film>().WithMany()
                        .HasForeignKey("Filmid")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("SYS_C00196465"),
                    j =>
                    {
                        j.HasKey("Filmid", "Rabattid").HasName("SYS_C00196464");
                        j.ToTable("FILM_RABATTAKTION");
                        j.IndexerProperty<decimal>("Filmid")
                            .HasColumnType("NUMBER")
                            .HasColumnName("FILMID");
                        j.IndexerProperty<decimal>("Rabattid")
                            .HasColumnType("NUMBER")
                            .HasColumnName("RABATTID");
                    });
        });

        modelBuilder.Entity<Kunde>(entity =>
        {
            entity.HasKey(e => e.Kundeid).HasName("SYS_C00196477");

            entity.ToTable("KUNDE");

            entity.HasIndex(e => e.Email, "SYS_C00196478").IsUnique();

            entity.Property(e => e.Kundeid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("KUNDEID");
            entity.Property(e => e.Adresse)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("ADRESSE");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("EMAIL");
            entity.Property(e => e.Geburtsdatum)
                .HasColumnType("DATE")
                .HasColumnName("GEBURTSDATUM");
            entity.Property(e => e.Nachname)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("NACHNAME");
            entity.Property(e => e.Telefon)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("TELEFON");
            entity.Property(e => e.Vorname)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("VORNAME");
        });

        modelBuilder.Entity<Preis>(entity =>
        {
            entity.HasKey(e => e.Preisid).HasName("SYS_C00196449");

            entity.ToTable("PREIS");

            entity.Property(e => e.Preisid)
            .HasConversion<decimal>()
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("PREISID");
            entity.Property(e => e.Beschreibung)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("BESCHREIBUNG");
            entity.Property(e => e.Betrag)
                .HasColumnType("NUMBER(5,2)")
                .HasColumnName("BETRAG");
        });

        modelBuilder.Entity<Rabattaktion>(entity =>
        {
            entity.HasKey(e => e.Rabattid).HasName("SYS_C00196462");

            entity.ToTable("RABATTAKTION");

            entity.Property(e => e.Rabattid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("RABATTID");
            entity.Property(e => e.Enddatum)
                .HasColumnType("DATE")
                .HasColumnName("ENDDATUM");
            entity.Property(e => e.Filmid)
                .HasColumnType("NUMBER")
                .HasColumnName("FILMID");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("NAME");
            entity.Property(e => e.Prozentsatz)
                .HasPrecision(3)
                .HasColumnName("PROZENTSATZ");
            entity.Property(e => e.Startdatum)
                .HasColumnType("DATE")
                .HasColumnName("STARTDATUM");

            entity.HasOne(d => d.Film).WithMany(p => p.Rabattaktions)
                .HasForeignKey(d => d.Filmid)
                .HasConstraintName("SYS_C00196463");
        });

        modelBuilder.Entity<Reservierung>(entity =>
        {
            entity.HasKey(e => e.Reservierungid).HasName("SYS_C00196479");

            entity.ToTable("RESERVIERUNG");

            entity.Property(e => e.Reservierungid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("RESERVIERUNGID");
            entity.Property(e => e.Kundeid)
                .HasColumnType("NUMBER")
                .HasColumnName("KUNDEID");
            entity.Property(e => e.Reservierungsdatum)
                .HasDefaultValueSql("SYSDATE")
                .HasColumnType("DATE")
                .HasColumnName("RESERVIERUNGSDATUM");
            entity.Property(e => e.Reservierungsstatus)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValueSql("'Ausstehend'")
                .HasColumnName("RESERVIERUNGSSTATUS");
            entity.Property(e => e.Vorstellungid)
                .HasColumnType("NUMBER")
                .HasColumnName("VORSTELLUNGID");

            entity.HasOne(d => d.Kunde).WithMany(p => p.Reservierungs)
                .HasForeignKey(d => d.Kundeid)
                .HasConstraintName("SYS_C00196480");

            entity.HasOne(d => d.Vorstellung).WithMany(p => p.Reservierungs)
                .HasForeignKey(d => d.Vorstellungid)
                .HasConstraintName("SYS_C00196481");
        });

        modelBuilder.Entity<Saal>(entity =>
        {
            entity.HasKey(e => e.Saalid).HasName("SYS_C00196457");

            entity.ToTable("SAAL");

            entity.HasIndex(e => e.Saalname, "SYS_C00196458").IsUnique();

            entity.Property(e => e.Saalid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("SAALID");
            entity.Property(e => e.Kapazitaet)
                .HasPrecision(3)
                .HasColumnName("KAPAZITAET");
            entity.Property(e => e.Saalname)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("SAALNAME");
            entity.Property(e => e.Typ)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasDefaultValueSql("'Standard'\n")
                .HasColumnName("TYP");
        });

        modelBuilder.Entity<Snack>(entity =>
        {
            entity.HasKey(e => e.Snackid).HasName("SYS_C00196493");

            entity.ToTable("SNACK");

            entity.HasIndex(e => e.Name, "SYS_C00196494").IsUnique();

            entity.Property(e => e.Snackid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("SNACKID");
            entity.Property(e => e.Beschreibung)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("BESCHREIBUNG");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("NAME");
            entity.Property(e => e.Preisid)

            .HasConversion<decimal>()
                .HasColumnType("NUMBER")
                .HasColumnName("PREISID");

            entity.HasOne(d => d.Preis).WithMany(p => p.Snacks)
                .HasForeignKey(d => d.Preisid)
                .HasConstraintName("SYS_C00196495");
        });

        modelBuilder.Entity<SnackKauf>(entity =>
        {
            entity.HasKey(e => e.Snackkaufid).HasName("SYS_C00196501");

            entity.ToTable("SNACK_KAUF");

            entity.Property(e => e.Snackkaufid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("SNACKKAUFID");
            entity.Property(e => e.Kaufdatum)
                .HasDefaultValueSql("SYSDATE")
                .HasColumnType("DATE")
                .HasColumnName("KAUFDATUM");
            entity.Property(e => e.Kundeid)
                .HasColumnType("NUMBER")
                .HasColumnName("KUNDEID");
            entity.Property(e => e.Menge)
                .HasPrecision(3)
                .HasColumnName("MENGE");
            entity.Property(e => e.Snackid)
                .HasColumnType("NUMBER")
                .HasColumnName("SNACKID");
            entity.Property(e => e.Zahlungsid)
                .HasColumnType("NUMBER")
                .HasColumnName("ZAHLUNGSID");

            entity.HasOne(d => d.Kunde).WithMany(p => p.SnackKaufs)
                .HasForeignKey(d => d.Kundeid)
                .HasConstraintName("SYS_C00196503");

            entity.HasOne(d => d.Snack).WithMany(p => p.SnackKaufs)
                .HasForeignKey(d => d.Snackid)
                .HasConstraintName("SYS_C00196502");

            entity.HasOne(d => d.Zahlungs).WithMany(p => p.SnackKaufs)
                .HasForeignKey(d => d.Zahlungsid)
                .HasConstraintName("SYS_C00196504");
        });

        modelBuilder.Entity<Ticket>(entity =>
        {
            entity.HasKey(e => e.Ticketid).HasName("SYS_C00196486");

            entity.ToTable("TICKET");

            entity.Property(e => e.Ticketid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("TICKETID");
            entity.Property(e => e.Kundeid)
                .HasColumnType("NUMBER")
                .HasColumnName("KUNDEID");
            entity.Property(e => e.Preisid)
            .HasConversion<decimal>()
                .HasColumnType("NUMBER")
                .HasColumnName("PREISID");
            entity.Property(e => e.Reservierungid)
                .HasColumnType("NUMBER")
                .HasColumnName("RESERVIERUNGID");
            entity.Property(e => e.Sitzplatz)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("SITZPLATZ");
            entity.Property(e => e.Vorstellungid)
                .HasColumnType("NUMBER")
                .HasColumnName("VORSTELLUNGID");
            entity.Property(e => e.Zahlungsid)
                .HasColumnType("NUMBER")
                .HasColumnName("ZAHLUNGSID");

            entity.HasOne(d => d.Kunde).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.Kundeid)
                .HasConstraintName("SYS_C00196488");

            entity.HasOne(d => d.Preis).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.Preisid)
                .HasConstraintName("SYS_C00196489");

            entity.HasOne(d => d.Reservierung).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.Reservierungid)
                .HasConstraintName("SYS_C00196491");

            entity.HasOne(d => d.Vorstellung).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.Vorstellungid)
                .HasConstraintName("SYS_C00196487");

            entity.HasOne(d => d.Zahlungs).WithMany(p => p.Tickets)
                .HasForeignKey(d => d.Zahlungsid)
                .HasConstraintName("SYS_C00196490");
        });

        modelBuilder.Entity<TicketSnack>(entity =>
        {
            entity.HasKey(e => new { e.Ticketid, e.Snackid }).HasName("SYS_C00196497");

            entity.ToTable("TICKET_SNACK");

            entity.Property(e => e.Ticketid)
                .HasColumnType("NUMBER")
                .HasColumnName("TICKETID");
            entity.Property(e => e.Snackid)
                .HasColumnType("NUMBER")
                .HasColumnName("SNACKID");
            entity.Property(e => e.Menge)
                .HasPrecision(3)
                .HasColumnName("MENGE");

            entity.HasOne(d => d.Snack).WithMany(p => p.TicketSnacks)
                .HasForeignKey(d => d.Snackid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("SYS_C00196499");

            entity.HasOne(d => d.Ticket).WithMany(p => p.TicketSnacks)
                .HasForeignKey(d => d.Ticketid)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("SYS_C00196498");
        });

        modelBuilder.Entity<Vorstellung>(entity =>
        {
            entity.HasKey(e => e.Vorstellungid).HasName("SYS_C00196470");

            entity.ToTable("VORSTELLUNG");

            entity.Property(e => e.Vorstellungid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("VORSTELLUNGID");
            entity.Property(e => e.Endzeit)
                .HasPrecision(6)
                .HasColumnName("ENDZEIT");
            entity.Property(e => e.Filmid)
                .HasColumnType("NUMBER")
                .HasColumnName("FILMID");
            entity.Property(e => e.Preisid)
            .HasConversion<decimal>()
                .HasColumnType("NUMBER")
                .HasColumnName("PREISID");
            entity.Property(e => e.Saalid)
                .HasColumnType("NUMBER")
                .HasColumnName("SAALID");
            entity.Property(e => e.Startzeit)
                .HasPrecision(6)
                .HasColumnName("STARTZEIT");

            entity.HasOne(d => d.Film).WithMany(p => p.Vorstellungs)
                .HasForeignKey(d => d.Filmid)
                .HasConstraintName("SYS_C00196471");

            entity.HasOne(d => d.Preis).WithMany(p => p.Vorstellungs)
                .HasForeignKey(d => d.Preisid)
                .HasConstraintName("SYS_C00196473");

            entity.HasOne(d => d.Saal).WithMany(p => p.Vorstellungs)
                .HasForeignKey(d => d.Saalid)
                .HasConstraintName("SYS_C00196472");
        });

        modelBuilder.Entity<Zahlung>(entity =>
        {
            entity.HasKey(e => e.Zahlungsid).HasName("SYS_C00196483");

            entity.ToTable("ZAHLUNG");

            entity.Property(e => e.Zahlungsid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("ZAHLUNGSID");
            entity.Property(e => e.Betrag)
                .HasColumnType("NUMBER(5,2)")
                .HasColumnName("BETRAG");
            entity.Property(e => e.Kundeid)
                .HasColumnType("NUMBER")
                .HasColumnName("KUNDEID");
            entity.Property(e => e.Zahlungsdatum)
                .HasDefaultValueSql("SYSDATE")
                .HasColumnType("DATE")
                .HasColumnName("ZAHLUNGSDATUM");
            entity.Property(e => e.Zahlungsmethodeid)
                .HasColumnType("NUMBER")
                .HasColumnName("ZAHLUNGSMETHODEID");

            entity.HasOne(d => d.Kunde).WithMany(p => p.Zahlungs)
                .HasForeignKey(d => d.Kundeid)
                .HasConstraintName("SYS_C00196485");

            entity.HasOne(d => d.Zahlungsmethode).WithMany(p => p.Zahlungs)
                .HasForeignKey(d => d.Zahlungsmethodeid)
                .HasConstraintName("SYS_C00196484");
        });

        modelBuilder.Entity<Zahlungsmethode>(entity =>
        {
            entity.HasKey(e => e.Zahlungsmethodeid).HasName("SYS_C00196446");

            entity.ToTable("ZAHLUNGSMETHODE");

            entity.HasIndex(e => e.Methode, "SYS_C00196447").IsUnique();

            entity.Property(e => e.Zahlungsmethodeid)
                .ValueGeneratedOnAdd()
                .HasColumnType("NUMBER")
                .HasColumnName("ZAHLUNGSMETHODEID");
            entity.Property(e => e.Methode)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("METHODE");
        });
        modelBuilder.HasSequence("DEPARTMENTS_SEQ").IncrementsBy(10);
        modelBuilder.HasSequence("EMPLOYEES_SEQ");
        modelBuilder.HasSequence("LOCATIONS_SEQ").IncrementsBy(100);
        modelBuilder.HasSequence("SEQ_FILM");
        modelBuilder.HasSequence("SEQ_KUNDE");
        modelBuilder.HasSequence("SEQ_PREIS");
        modelBuilder.HasSequence("SEQ_RABATTAKTION");
        modelBuilder.HasSequence("SEQ_RESERVIERUNG");
        modelBuilder.HasSequence("SEQ_SAAL");
        modelBuilder.HasSequence("SEQ_SNACK");
        modelBuilder.HasSequence("SEQ_SNACKKAUF");
        modelBuilder.HasSequence("SEQ_TICKET");
        modelBuilder.HasSequence("SEQ_VORSTELLUNG");
        modelBuilder.HasSequence("SEQ_ZAHLUNG");
        modelBuilder.HasSequence("SEQ_ZAHLUNGSMETHODE");


        

        
        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
