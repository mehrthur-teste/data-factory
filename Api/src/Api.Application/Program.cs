using Api.CrossCutting.DependencyInjection;
using Api.CrossCutting.Database;

var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// ✅ BANCO
builder.Services.AddDatabase(builder.Configuration);

// ✅ INJEÇÕES (Services, Repositories, etc)
builder.Services.AddDependencies();

// ✅ Swagger (NET 8)
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();
app.MapControllers();
app.Run();
