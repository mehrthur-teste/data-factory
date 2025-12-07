#!/bin/bash

echo "========================================"
echo "CRIANDO CLASSES BASE + USER (DDD + EF)"
echo "========================================"

BASE_PATH="Api/src"

# ================================
# DOMAIN
# ================================
echo "Criando classes no Api.Domain..."

mkdir -p $BASE_PATH/Api.Domain/Entities
mkdir -p $BASE_PATH/Api.Domain/Interfaces

cat <<EOF > $BASE_PATH/Api.Domain/Entities/BaseEntity.cs
using System;

namespace Api.Domain.Entities
{
    public abstract class BaseEntity
    {
        public Guid Id { get; set; }
        public DateTime CreateAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdateAt { get; set; }
    }
}
EOF

cat <<EOF > $BASE_PATH/Api.Domain/Entities/UserEntity.cs
namespace Api.Domain.Entities
{
    public class UserEntity : BaseEntity
    {
        public string Name { get; set; }
        public string Email { get; set; }
    }
}
EOF

cat <<EOF > $BASE_PATH/Api.Domain/Interfaces/IRepository.cs
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Api.Domain.Entities;

namespace Api.Domain.Interfaces
{
    public interface IRepository<T> where T : BaseEntity
    {
        Task<T> InsertAsync(T item);
        Task<T> UpdateAsync(T item);
        Task<bool> DeleteAsync(Guid id);
        Task<T> SelectAsync(Guid id);
        Task<IEnumerable<T>> SelectAsync();
    }
}
EOF

# ================================
# DATA
# ================================
echo "Criando classes no Api.Data..."

mkdir -p $BASE_PATH/Api.Data/Context
mkdir -p $BASE_PATH/Api.Data/Mapping
mkdir -p $BASE_PATH/Api.Data/Repository

cat <<EOF > $BASE_PATH/Api.Data/Context/MyContext.cs
using Microsoft.EntityFrameworkCore;
using Api.Domain.Entities;
using Api.Data.Mapping;

namespace Api.Data.Context
{
    public class MyContext : DbContext
    {
        public MyContext(DbContextOptions<MyContext> options)
            : base(options)
        {
        }

        public DbSet<UserEntity> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new UserMap());
            base.OnModelCreating(modelBuilder);
        }
    }
}
EOF

cat <<EOF > $BASE_PATH/Api.Data/Mapping/UserMap.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Api.Domain.Entities;

namespace Api.Data.Mapping
{
    public class UserMap : IEntityTypeConfiguration<UserEntity>
    {
        public void Configure(EntityTypeBuilder<UserEntity> builder)
        {
            builder.ToTable("Users");

            builder.HasKey(x => x.Id);

            builder.Property(x => x.Name)
                   .IsRequired()
                   .HasMaxLength(100);

            builder.Property(x => x.Email)
                   .IsRequired()
                   .HasMaxLength(150);

            builder.HasIndex(x => x.Email)
                   .IsUnique();
        }
    }
}
EOF

cat <<EOF > $BASE_PATH/Api.Data/Repository/BaseRepository.cs
using Api.Domain.Entities;
using Api.Domain.Interfaces;
using Api.Data.Context;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Api.Data.Repository
{
    public class BaseRepository<T> : IRepository<T> where T : BaseEntity
    {
        protected readonly MyContext _context;
        protected DbSet<T> _dataset;

        public BaseRepository(MyContext context)
        {
            _context = context;
            _dataset = _context.Set<T>();
        }

        public async Task<T> InsertAsync(T item)
        {
            item.Id = Guid.NewGuid();
            _dataset.Add(item);
            await _context.SaveChangesAsync();
            return item;
        }

        public async Task<T> UpdateAsync(T item)
        {
            _dataset.Update(item);
            await _context.SaveChangesAsync();
            return item;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var item = await _dataset.FindAsync(id);
            if (item == null) return false;

            _dataset.Remove(item);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<T> SelectAsync(Guid id)
        {
            return await _dataset.FindAsync(id);
        }

        public async Task<IEnumerable<T>> SelectAsync()
        {
            return await _dataset.ToListAsync();
        }
    }
}
EOF

# ================================
# BUILD FINAL
# ================================
echo "Compilando solução..."
cd $BASE_PATH || exit
dotnet build

echo "========================================"
echo "✅ CLASSES BASE E USER CRIADAS COM SUCESSO"
echo "========================================"
