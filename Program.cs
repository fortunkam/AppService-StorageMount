using Microsoft.AspNetCore.Mvc;
using System.IO;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapPost("/savefile",([FromBody]object content, [FromServices]IConfiguration configuration) => {
    var path = configuration.GetValue<string>("MountPath");
    var fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".json";
    var filePath = $"{path}/{fileName}";

    File.WriteAllText(filePath, content.ToString());
    return $"File Written to {filePath}";

});

app.Run();
