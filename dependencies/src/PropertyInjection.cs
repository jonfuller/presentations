public class MovieLister
{
    private readonly IMovieFinder _finder;

    public MovieLister()
    {
    }

    public IMovieFinder Finder
    {
        get;
        set;
    }

    public IEnumerable<Movie> MoviesDirectedBy(string director)
    {
        return _finder
                 .FindAll()
                 .Where(movie => movie.Director == director);
    }
}
