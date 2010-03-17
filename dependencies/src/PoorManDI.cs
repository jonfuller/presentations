public class MovieLister
{
    private readonly IMovieFinder _finder;

    public MovieLister()
      : this(ServiceLocator.Locate<IMovieFinder>())
    {
    }

    public MovieLister(IMovieFinder finder)
    {
       _finder = finder;
    }

    public IEnumerable<Movie> MoviesDirectedBy(string director)
    {
        return _finder
                 .FindAll()
                 .Where(movie => movie.Director == director);
    }
}
