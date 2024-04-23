float hash(uvec2 x)
{
    uvec2 q = 1103515245U * ((x >> 1U) ^ (x.yx));
    uint n = 1103515245U * ((q.x) ^ (q.y >> 3U));
    return float(n) * (1.0 / float(0xffffffffU));
}
