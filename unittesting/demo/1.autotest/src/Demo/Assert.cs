using System;

namespace Demo
{
    public static class Assert
    {
        public static void Throws<T>(Action action)
        {
            try
            {
                action();
            }
            catch(Exception e)
            {
                if(e is T)
                    return;

                throw;
            }
        }
    }
}