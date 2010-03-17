public class Program
{
    public static void Main()
    {
        ObjectFactory.Configure(cfg =>
        {
            cfg.For<IMovieFinder>()
               .Use<DatabaseMovieFinder>()
               .InterceptWith(new LoggingInterceptor());

            cfg.For<IDbConnection>().Singleton().Use<SqlConnection>()
                .Ctor<string>().Is("connection_string");
        });

        var lister = ObjectFactory.GetInstance<MovieLister>());

        lister.MoviesDirectedBy("Kubrick").Each(
            movie => Console.WriteLine(movie.ToString()));
    }
}
