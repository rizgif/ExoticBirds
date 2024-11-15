using System.ComponentModel.DataAnnotations;

public class Bird
{
    [Key]
    public int ID { get; set; }

    [Required]
    [MaxLength(100)]
    public string Name { get; set; }

    [MaxLength(500)]
    public string Description { get; set; }

    // List of countries associated with the bird, comma-separated
    [MaxLength(200)]  // Adjust as needed
    public string Countries { get; set; }

    // Base64 version of the image with max width 100px-300px
    [Required]
    public string Base64Image { get; set; }

    // Image width with constraint from 100px to 300px
    [Range(100, 300)]
    public int Width { get; set; } = 300;
}
