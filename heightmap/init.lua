math.randomseed(os.time())

local heightmap = require((...):gsub("%.", "/") .. "/heightmap")

local floor = math.floor

local function min(t)
    local r = t[0][0]
    for i=0,#t do
        for j=0,#t[0] do
            if r > t[i][j] then r = t[i][j] end
        end
    end
    return r
end

local function max(t)
    local r = t[0][0]
    for i=0,#t do
        for j=0,#t[0] do
            if r < t[i][j] then r = t[i][j] end
        end
    end
    return r
end

local function normalize(map, new_min, new_max)
  local minimum = min(map)
  local initialRange = max(map) - minimum
  local finalRange = new_max - new_min
  for i = 0, #map do
    for j = 0, #map[0] do
      map[i][j] = (map[i][j] - minimum) / initialRange * finalRange + new_min
    end
  end
  map.min = min(map)
  map.max = max(map)
  return map -- superfluous
end

local function create(width, height, f_or_min, min_or_max, max_if_f)
  local map, rangeMin, rangeMax
    if type(f_or_min) == "function" then
        map = heightmap.create(width, height, f)
        rangeMin = min_or_max
        rangeMax = max_if_f
    else
        map = heightmap.create(width, height)
        rangeMin = f_or_min
        rangeMax = min_or_max
    end

    return normalize(map, rangeMin, rangeMax)
end

return {
    create = create,
    defaultf = heightmap.defaultf,
    normalize = normalize,
}
