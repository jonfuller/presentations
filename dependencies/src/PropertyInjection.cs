public class MovieLister
{
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
        return Finder
                 .FindAll()
                 .Where(movie => movie.Director == director);
    }
}
