using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;



namespace ExoticBirdsAPI.Data
{


public class BirdContext : DbContext
{
    public BirdContext(DbContextOptions<BirdContext> options) : base(options) { }

    public DbSet<Bird> Birds { get; set; }
}

}