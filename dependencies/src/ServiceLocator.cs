public class MovieLister
{
    private readonly IMovieFinder _finder;

    public MovieLister()
    {
        _finder = ServiceLocator.Locate<IMovieFinder>();
    }

    public IEnumerable<Movie> MoviesDirectedBy(string director)
    {
        return _finder
                 .FindAll()
                 .Where(movie => movie.Director == director);
    }
}
