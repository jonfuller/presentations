using System;
using System.Collections.Generic;

namespace Demo
{
    public static class Ext
    {
        public static void Each<T>(this IEnumerable<T> target, Action<T> toPerform)
        {
            foreach(var item in target)
                toPerform(item);
        }
    }
}