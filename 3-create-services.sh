#!/bin/bash

echo "========================================"
echo "CRIANDO IUserService + UserService"
echo "========================================"

BASE_PATH="Api/src"

# ================================
# DOMAIN - Interface do Service
# ================================
mkdir -p $BASE_PATH/Api.Domain/Interfaces/Services/User
mkdir -p $BASE_PATH/Api.Domain/Services/User

cat <<EOF > $BASE_PATH/Api.Domain/Interfaces/Services/User/IUserService.cs
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Api.Domain.Entities;

namespace Api.Domain.Interfaces.Services.User
{
    public interface IUserService
    {
        Task<UserEntity> Get(Guid id);
        Task<IEnumerable<UserEntity>> GetAll();
        Task<UserEntity> Post(UserEntity user);
        Task<UserEntity> Put(UserEntity user);
        Task<bool> Delete(Guid id);
    }
}
EOF

# ================================
# SERVICE - Implementação
# ================================
mkdir -p $BASE_PATH/Api.Service/Services

cat <<EOF > $BASE_PATH/Api.Service/Services/User/UserService.cs
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Api.Domain.Entities;
using Api.Domain.Interfaces;
using Api.Domain.Interfaces.Services.User;

namespace Api.Service.Services
{
    public class UserService : IUserService
    {
        private readonly IRepository<UserEntity> _repository;

        public UserService(IRepository<UserEntity> repository)
        {
            _repository = repository;
        }

        public async Task<UserEntity> Get(Guid id)
        {
            return await _repository.SelectAsync(id);
        }

        public async Task<IEnumerable<UserEntity>> GetAll()
        {
            return await _repository.SelectAsync();
        }

        public async Task<UserEntity> Post(UserEntity user)
        {
            return await _repository.InsertAsync(user);
        }

        public async Task<UserEntity> Put(UserEntity user)
        {
            return await _repository.UpdateAsync(user);
        }

        public async Task<bool> Delete(Guid id)
        {
            return await _repository.DeleteAsync(id);
        }
    }
}
EOF

cd $BASE_PATH || exit
dotnet build

echo "✅ Services criados com sucesso!"
