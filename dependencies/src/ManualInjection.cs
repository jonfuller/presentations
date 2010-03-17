public class Program
{
    public static void Main()
    {
        var lister = new MovieLister(new ImdbMovieFinder());

        lister.MoviesDirectedBy("Kubrick").Each(
            movie => Console.WriteLine(movie.ToString()));
    }
}
