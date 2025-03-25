import { useState } from 'react';
import { Container, Box, TextField, MenuItem, Button, Table, TableContainer, Paper, TableHead, TableRow, TableCell, TableBody, Alert } from '@mui/material';
import { simulatePlansApi, SimulatePlansResponse} from './api/simulate-plans-api';
import './App.css';

const ampereOptions = [10, 15, 20, 30, 40, 50, 60];

function App() {
  const [ampere, setAmpere] = useState<number | string>('');
  const [consumption, setConsumption] = useState <number | string>('');
  const [plans, setPlans] = useState<SimulatePlansResponse[]>([]);
  const [error, setError] = useState<string | null>(null);

  const handleAmpereChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setAmpere(Number(event.target.value));
  };

  const handleConsumptionChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setConsumption(Number(event.target.value));
  };

  const handleSubmit = async () => {
    try {
      const response = await simulatePlansApi({ ampere: Number(ampere), consumption: Number(consumption) });
      setPlans(response.data);
      setError(null);
    } catch  {
      setError('シミュレーションの取得に失敗しました');
    }
  };

  return (
    <Container>
      <Box sx={{ textAlign: 'center', mt: 4 }}>
        <Box sx={{ mt: 2 }}>
          <TextField
            select
            label="契約アンペア数"
            value={ampere}
            onChange={handleAmpereChange}
            variant="outlined"
            fullWidth
            margin="normal"
          >
            {ampereOptions.map((option) => (
              <MenuItem key={option} value={option}>
                {option}A
              </MenuItem>
            ))}
          </TextField>
          <TextField
            label="使用量 (kWh)"
            type="number"
            value={consumption.toString()}
            onChange={handleConsumptionChange}
            variant="outlined"
            fullWidth
            margin="normal"
          />
          <Button variant="contained" color="primary" onClick={handleSubmit} sx={{ mt: 2 }}>
            送信
          </Button>
          {error && (
            <Alert severity="error" sx={{ mt: 2 }}>
              {error}
            </Alert>
          )}
          {plans.length > 0 && (
            <TableContainer component={Paper} sx={{ mt: 4 }}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>電力会社</TableCell>
                  <TableCell>電力プラン</TableCell>
                  <TableCell>価格(円)</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {plans.map((row, index) => (
                  <TableRow key={index}>
                    <TableCell>{row.providerName}</TableCell>
                    <TableCell>{row.planName}</TableCell>
                    <TableCell>{row.price.toLocaleString()}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
          )}
        </Box>
      </Box>
    </Container>
  );
}

export default App;
