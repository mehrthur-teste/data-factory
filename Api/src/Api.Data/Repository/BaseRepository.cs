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
