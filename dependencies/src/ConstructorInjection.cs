public class MovieLister
{
    private readonly IMovieFinder _finder;

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
