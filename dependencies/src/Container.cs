public class Program
{
    public static void Main()
    {
        ObjectFactory.Configure(cfg =>
        {
            cfg.For<IMovieFinder>().Use<ImbdMovieFinder>();
        });

        var lister = new MovieLister(
            ObjectFactory.GetInstance<IMovieFinder>());

        lister.MoviesDirectedBy("Kubrick").Each(
            movie => Console.WriteLine(movie.ToString()));
    }
}
