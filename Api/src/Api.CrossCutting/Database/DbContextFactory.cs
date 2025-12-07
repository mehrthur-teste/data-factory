using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Api.Data.Context;

namespace Api.CrossCutting.Database
{
    public static class DbContextFactory
    {
        public static IServiceCollection AddDatabase(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            services.AddDbContext<MyContext>(options =>
                options.UseSqlServer(
                    configuration.GetConnectionString("DefaultConnection"))
            );

            return services;
        }
    }
}
