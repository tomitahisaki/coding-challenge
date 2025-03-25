import client from './index';

type SimulatePlansParams = {
  ampere: number;
  consumption: number;
}

export type SimulatePlansResponse = {
  providerName: string;
  planName: string;
  price: number;
}

export const simulatePlansApi = async (params: SimulatePlansParams) => {
  const data = await client.get<SimulatePlansResponse[]>('/simulate_plans', { params });
  return data;
}
