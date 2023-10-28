```
$ echo '
shader root()
{
    float my_var = u * 2;
    if (my_var > 0.5)
        my_var += 2;
    else
        printf("else!\n");
    printf("my_var = %f\n", my_var);
}
' > root.osl

$ oslc root.osl
$ testshade -shader root root_layer
$ dot -Tpng bblock--shader-unnamed_group_1--layer-root_layer.dot > cfg.png
$ open cfg.png
```
