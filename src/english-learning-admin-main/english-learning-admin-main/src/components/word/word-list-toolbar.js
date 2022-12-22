import {
    Box,
    Button,
    Card,
    CardContent,
    TextField,
    InputAdornment,
    SvgIcon, Typography
  } from '@mui/material';
  import { Search as SearchIcon } from '../../icons/search';
  import { useRouter } from 'next/router';
  
  export const WordListToolbar = (props) => {
    const router = useRouter();
    const handleAdd = (word_id) => {
      // console.log(word_id);
      router.push('/words/add-word');
    };
    return(
      <Box {...props}>
        <Box
          sx={{
            alignItems: 'center',
            display: 'flex',
            justifyContent: 'space-between',
            flexWrap: 'wrap',
            m: -1
          }}
        >
          <Typography
            sx={{ m: 1 }}
            variant="h4"
          >
            Words
          </Typography>
          <Box sx={{ m: 1 }}>
            
            <Button
              color="primary"
              variant="contained"
              onClick={() => handleAdd()}
            >
              Add Words
            </Button>
          </Box>
        </Box>
        <Box sx={{ mt: 3 }}>
          <Card>
            <CardContent>
              <Box sx={{ maxWidth: 500 }}>
                <TextField
                  fullWidth
                  InputProps={{
                    startAdornment: (
                      <InputAdornment position="start" onChange = {props.onChange_Search}>
                        <SvgIcon
                          color="action"
                          fontSize="small"
                        >
                          <SearchIcon />
                        </SvgIcon>
                      </InputAdornment>
                    )
                  }}
                  placeholder="Search Word"
                  variant="outlined"
                />
              </Box>
            </CardContent>
          </Card>
        </Box>
      </Box>
    );
  }
  