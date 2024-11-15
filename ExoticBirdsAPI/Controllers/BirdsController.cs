using ExoticBirdsAPI.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;

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
        // Validate Base64Image and Width properties
        if (!IsValidBase64(bird.Base64Image))
        {
            ModelState.AddModelError("Base64Image", "Invalid Base64 image format.");
            return BadRequest(ModelState);
        }

        if (bird.Width < 100 || bird.Width > 300)
        {
            ModelState.AddModelError("Width", "Width must be between 100px and 300px.");
            return BadRequest(ModelState);
        }

        _context.Birds.Add(bird);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetBird), new { id = bird.ID }, bird);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutBird(int id, Bird bird)
    {
        if (id != bird.ID) return BadRequest();

        // Validate Base64Image and Width properties
        if (!IsValidBase64(bird.Base64Image))
        {
            ModelState.AddModelError("Base64Image", "Invalid Base64 image format.");
            return BadRequest(ModelState);
        }

        if (bird.Width < 100 || bird.Width > 300)
        {
            ModelState.AddModelError("Width", "Width must be between 100px and 300px.");
            return BadRequest(ModelState);
        }

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

    // Helper method to validate Base64 format
    private bool IsValidBase64(string base64String)
    {
        if (string.IsNullOrEmpty(base64String)) return false;

        // Base64 regex pattern
        string base64Pattern = @"^[a-zA-Z0-9\+/]*={0,2}$";
        bool isMatch = Regex.IsMatch(base64String, base64Pattern);

        // Ensure the length is a multiple of 4 (a characteristic of valid Base64 strings)
        return isMatch && (base64String.Length % 4 == 0);
    }
}
