using Microsoft.Extensions.DependencyInjection;
using Api.Domain.Interfaces.Services.User;
using Api.Service.Services;
using Api.Domain.Interfaces;
using Api.Domain.Entities;
using Api.Data.Repository;

namespace Api.CrossCutting.DependencyInjection
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddDependencies(this IServiceCollection services)
        {
            // Services
            services.AddScoped<IUserService, UserService>();

            // Repositories
            services.AddScoped<IRepository<UserEntity>, BaseRepository<UserEntity>>();

            return services;
        }
    }
}
