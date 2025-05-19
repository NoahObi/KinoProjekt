using GrueneisR.RestClientGenerator;
//using KinoprojectLibary;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);



builder.Services
    .AddEndpointsApiExplorer()
    .AddSwaggerGen();

//builder.Services.AddDbContext<DatabaseContext>();

builder.Services.AddRestClientGenerator(options => options
    .SetFolder(Environment.CurrentDirectory)
    .SetFilename("_requests.http")
    .SetAction("swagger/v1/swagger.json")
);



var app = builder.Build();
app.MapGet("/", () => Results.Redirect("/Swagger"));


app.UseSwagger();
app.UseSwaggerUI();


app.Run();
