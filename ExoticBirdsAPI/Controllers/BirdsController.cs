//BirdController.cs
using ExoticBirdsAPI.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/[controller]")]
[ApiController]
public class BirdsController : ControllerBase
{
    private readonly BirdContext _context;

    public BirdsController(BirdContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Bird>>> GetBirds()
    {
        return await _context.Birds.ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Bird>> GetBird(int id)
    {
        var bird = await _context.Birds.FindAsync(id);

        if (bird == null) return NotFound();

        return bird;
    }

    [HttpPost]
    public async Task<ActionResult<Bird>> PostBird(Bird bird)
    {
        _context.Birds.Add(bird);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetBird), new { id = bird.ID }, bird);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutBird(int id, Bird bird)
    {
        if (id != bird.ID) return BadRequest();

        _context.Entry(bird).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.Birds.Any(e => e.ID == id)) return NotFound();
            else throw;
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteBird(int id)
    {
        var bird = await _context.Birds.FindAsync(id);
        if (bird == null) return NotFound();

        _context.Birds.Remove(bird);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
