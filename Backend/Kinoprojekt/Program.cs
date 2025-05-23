using Database;
using GrueneisR.RestClientGenerator;
using Kinoprojekt.DTOs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace Kinoprojekt
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddControllers();

            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.Preserve;
            });



            //builder.Services.AddDbContext<DatabaseContext>(options =>
            //options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
            builder.Services.AddDbContext<DatabaseContext>();
            builder.Services
            .AddEndpointsApiExplorer()
            .AddSwaggerGen();

            builder.Services.AddRestClientGenerator(options => options
                .SetFolder(Environment.CurrentDirectory)
                .SetFilename("_requests.http")
                .SetAction("swagger/v1/swagger.json")
            );

            var app = builder.Build();


            app.UseSwagger();
            app.UseSwaggerUI();

            app.MapGet("/", () => Results.Redirect("/swagger"));

            app.MapGet("/vorstellungen/heute", ([FromServices] DatabaseContext db) =>
            {
                var heute = DateTime.Today;
                var vorstellungen = db.Vorstellungs
                    .Where(v => v.Startzeit <= heute && v.Endzeit>= heute)
                    .Select(v => new {
                        v.Vorstellungid,
                        FilmTitel = v.Film.Titel,
                        v.Startzeit,
                        v.Endzeit,
                        SaalName = v.Saal.Saalname
                    })
                    .OrderBy(v => v.Startzeit)
                    .ToList();

                return vorstellungen;
            });

            app.MapPost("/tickets", ([FromServices]DatabaseContext db, TicketDto ticketDto) =>
            {
                var ticket = new Ticket
                {
                    Vorstellungid = ticketDto.VorstellungID,
                    Kundeid = ticketDto.KundeID,
                    Sitzplatz = ticketDto.Sitzplatz,
                    Preisid = ticketDto.PreisID,
                    Zahlungsid = ticketDto.ZahlungsID,
                    Reservierungid = ticketDto.ReservierungID
                };

                db.Tickets.Add(ticket);
                db.SaveChanges();

                // Snacks hinzufügen
                if (ticketDto.SnackMengen != null)
                {
                    foreach (var snack in ticketDto.SnackMengen)
                    {
                        db.TicketSnacks.Add(new TicketSnack
                        {
                            Ticketid = ticket.Ticketid,
                            Snackid = snack.SnackID,
                            Menge = snack.Menge,
                        });
                    }
                    db.SaveChanges();
                }

                return ticket;
            });
            

            app.MapGet("/rabattaktionen/aktiv", ([FromServices]DatabaseContext db) =>
            {
                var heute = DateTime.Today;
                var rabatte = db.Rabattaktions
                    .Where(r => r.Startdatum <= heute && r.Enddatum >= heute)
                    .Select(r => new {
                        r.Rabattid, 
                        r.Name,
                        r.Prozentsatz,
                        FilmTitel = r.Film.Titel
                    })
                    .ToList();

                return rabatte;
            });

            
            app.Run();
        }
    }
}
