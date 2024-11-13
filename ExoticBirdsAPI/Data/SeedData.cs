using System.Text;
using System.Collections.Generic;
using ExoticBirdsAPI.Data;

public static class SeedData
{
    public static void Initialize(BirdContext context)
    {
        if (context.Birds.Any()) return; // DB has been seeded

        var birds = new List<Bird>
        {
            new Bird
            {
                Name = "Toucan",
                Description = "A colorful bird known for its large, vibrant beak.",
                Countries = "Brazil, Argentina, Paraguay",
                Image = "/images/toucan.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/toucan.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Bald Eagle",
                Description = "A powerful bird of prey, known for its white head.",
                Countries = "USA, Canada",
                Image = "/images/bald_eagle.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/bald_eagle.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Emperor Penguin",
                Description = "Largest species of penguin, known for its black and white coloring.",
                Countries = "Antarctica",
                Image = "/images/emperor_penguin.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/emperor_penguin.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Peacock",
                Description = "A beautiful bird known for its iridescent tail feathers.",
                Countries = "India, Sri Lanka",
                Image = "/images/peacock.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/peacock.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Macaw",
                Description = "A large, colorful parrot with a long tail.",
                Countries = "Brazil, Colombia",
                Image = "/images/macaw.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/macaw.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Great Horned Owl",
                Description = "A large owl with distinctive ear tufts and yellow eyes.",
                Countries = "USA, Canada, Mexico",
                Image = "/images/great_horned_owl.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/great_horned_owl.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Kiwi",
                Description = "A small, flightless bird native to New Zealand.",
                Countries = "New Zealand",
                Image = "/images/kiwi.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/kiwi.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Scarlet Ibis",
                Description = "A bright red wading bird found in South America.",
                Countries = "Venezuela, Colombia",
                Image = "/images/scarlet_ibis.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/scarlet_ibis.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Kakapo",
                Description = "A large, nocturnal parrot native to New Zealand, critically endangered.",
                Countries = "New Zealand",
                Image = "/images/kakapo.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/kakapo.jpg"),
                Width = 300
            },
            new Bird
            {
                Name = "Golden Eagle",
                Description = "A large bird of prey known for its strength and agility.",
                Countries = "Europe, North America, Asia",
                Image = "/images/golden_eagle.jpg",
                Base64Image = ConvertImageToBase64("wwwroot/images/golden_eagle.jpg"),
                Width = 300
            }
        };

        context.Birds.AddRange(birds);
        context.SaveChanges();
    }

    private static string ConvertImageToBase64(string imagePath)
    {
        byte[] imageBytes = File.ReadAllBytes(imagePath);
        return Convert.ToBase64String(imageBytes);
    }
}
