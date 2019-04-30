root <- rprojroot::find_rstudio_root_file()
dataDir <- file.path(root, 'data')

# DiamondColors.csv
download.file(
	'https://query.data.world/s/uVlTdijkCbfac49-3k12tawsmviArp',
	destfile=file.path(dataDir, 'DiamondColors.csv'),
	mode='w')

# diamonds.db
download.file(
	'https://query.data.world/s/Z5k9W39e1kD5hzcJIcRlFClhIHnw5v',
	destfile=file.path(dataDir, 'diamonds.db'),
	mode='wb')

# ExcelExample.xlsx
download.file(
	'https://query.data.world/s/5wa6K_X91yfkf-BVpRe2UIabO5A-QB',
	destfile=file.path(dataDir, 'ExcelExample.xlsx'),
	mode='wb')

# FavoriteSpots.json
download.file(
	'https://query.data.world/s/033kPeDH9pMdcnhPRIOwhjrw3lpA10',
	destfile=file.path(dataDir, 'FavoriteSpots.json'),
	mode='w')

# flightPaths.csv
download.file(
	'https://query.data.world/s/IIwWxfh9cTydB8h_OueRyA7yxvZ6bf',
	destfile=file.path(dataDir, 'flightPaths.csv'),
	mode='w')

# reaction.txt
download.file(
	'https://query.data.world/s/uDfiLMRxSiB_kQQhEt_LbDGVOcStBR',
	destfile=file.path(dataDir, 'reaction.txt'),
	mode='w')

# ribalta.html
download.file(
	'https://query.data.world/s/kK6-MCw-EbRmnwP-e2MmhEL82lLU4N',
	destfile=file.path(dataDir, 'ribalta.html'),
	mode='w')

# SocialComments.xml
download.file(
	'https://query.data.world/s/vzZ_zJzCqXY_yExaJIt79XkJAqUbe-',
	destfile=file.path(dataDir, 'SocialComments.xml'),
	mode='w')

# TomatoFirst.csv
download.file(
	'https://query.data.world/s/o_LrhM_oY5dexXVDbsMNxF2JyyIMrg',
	destfile=file.path(dataDir, 'TomatoFirst.csv'),
	mode='w')

# visited.csv
download.file(
	'https://query.data.world/s/GCIO0yVrO50N130s_CZNK50ujmqrE3',
	destfile=file.path(dataDir, 'visited.csv'),
	mode='w')

# manhattan_Test.rds
download.file(
	'https://query.data.world/s/tkfdrcapfsw7ihodbjzsdywz7povce',
	destfile=file.path(dataDir, 'manhattan_Test.rds'),
	mode='wb')

# manhattan_Train.rds
download.file(
	'https://query.data.world/s/4tjm263dwjq5knfs5upekzlmzc6oa2',
	destfile=file.path(dataDir, 'manhattan_Train.rds'),
	mode='wb')

# manhattan_Validate.rds
download.file(
	'https://query.data.world/s/4tfwbez3ul5ap7apg2ffgltfpzmifm',
	destfile=file.path(dataDir, 'manhattan_Validate.rds'),
	mode='wb')

# manhattan_Train.csv
download.file(
	'https://query.data.world/s/zGvNwNJbY2470sjsVxYFstm426SEf1',
	destfile=file.path(dataDir, 'manhattan_Train.csv'),
	mode='w')

# BronxCensus.csv
download.file(
	'https://query.data.world/s/cn2vamfwb5drulpw7n2qvhi73przsw',
	destfile=file.path(dataDir, 'BronxCensus.csv'),
	mode='w')

# BrooklynCensus.csv
download.file(
	'https://query.data.world/s/avar5wr4g6smqlcv2rtwvq7kyxyhsy',
	destfile=file.path(dataDir, 'BrooklynCensus.csv'),
	mode='w')

# ManhattanCensus.csv
download.file(
	'https://query.data.world/s/t3skwmjqswi26k4yanyvx42emomh62',
	destfile=file.path(dataDir, 'ManhattanCensus.csv'),
	mode='w')

# QueensCensus.csv
download.file(
	'https://query.data.world/s/ba36t26elr3wbkc673lr7va342c5kw',
	destfile=file.path(dataDir, 'QueensCensus.csv'),
	mode='w')

# StatenIslandCensus.csv
download.file(
	'https://query.data.world/s/bkvlmqibuuu6tdm57dt2rzoa4on4xv',
	destfile=file.path(dataDir, 'StatenIslandCensus.csv'),
	mode='w')

