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

    public string Countries { get; set; }

    public string Image { get; set; }  // URL or file path for the image

    public string Base64Image { get; set; }  // Base64 version of the image

    [Range(0, 300)]
    public int Width { get; set; } = 300;  // Max width of 300px

}
